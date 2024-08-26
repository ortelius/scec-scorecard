// Package main implements the Ortelius v11 Scorecard Microservice, which provides a REST API
// to retrieve OpenSSF Scorecard metrics for a given repository and commit SHA. This microservice
// uses the Fiber web framework for handling HTTP requests and integrates with the OpenSSF Scorecard
// API to fetch security-related metrics. Additionally, it provides a Swagger UI for API documentation
// and a health check endpoint for Kubernetes deployments. The microservice is configured to log
// in a human-readable format using the Zap logging library.
package main

import (
	"github.com/ortelius/scec-commons/model"
	_ "github.com/ortelius/scec-scorecard/docs"

	"encoding/json"
	"os"
	"os/exec"
	"strings"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"

	"github.com/go-resty/resty/v2"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/swagger"
	ossf "github.com/ossf/scorecard/v5/pkg/scorecard"
)

const scorecardAPIBaseURL = "https://api.securityscorecards.dev/projects/"

// InitLogger sets up the Zap Logger to log to the console in a human readable format
func InitLogger() *zap.Logger {
	prodConfig := zap.NewProductionConfig()
	prodConfig.Encoding = "console"
	prodConfig.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	prodConfig.EncoderConfig.EncodeDuration = zapcore.StringDurationEncoder
	logger, _ := prodConfig.Build()
	return logger
}

var logger = InitLogger()
var client = resty.New()

// getScorecard godoc
// @Summary Get the OSSF scorecard for a repo
// @Description Get a scorecard for a repo and commit sha
// @Tags scorecard
// @Accept */*
// @Produce json
// @Success 200
// @Router /msapi/scorecard/:key [get]
func getScorecard(c *fiber.Ctx) error {
	var scorecard model.Scorecard

	repoURL := c.Params("*")
	commitSha := c.Query("commit")

	if repoURL == "" {
		return c.JSON(scorecard)
	}

	githubURL := cleanRepoURL(repoURL)

	fullURL := scorecardAPIBaseURL + githubURL
	if commitSha != "" {
		fullURL += "?commit=" + commitSha
	}

	resp, err := client.R().Get(fullURL)
	if err != nil {
		return c.JSON(scorecard) // handle error
	}

	if resp.StatusCode() == fiber.StatusOK {
		return c.JSON(parseScoreCard(resp, commitSha))
	}

	// Retry without commitSha if the first attempt fails
	if commitSha != "" {
		fullURL = scorecardAPIBaseURL + githubURL
		resp, err = client.R().Get(fullURL)
		if err != nil {
			return c.JSON(scorecard)
		}

		if resp.StatusCode() == fiber.StatusOK {
			return c.JSON(parseScoreCard(resp, commitSha))
		}
	}

	// If failed and GITHUB_TOKEN is available, fallback to CLI
	if token := os.Getenv("GITHUB_TOKEN"); token != "" && strings.Contains(githubURL, "github.com") && commitSha != "" {
		return c.JSON(fetchScoreCardWithCLI(githubURL, commitSha))
	}

	return c.JSON(scorecard)
}

func cleanRepoURL(repoURL string) string {
	replacements := []struct {
		old string
		new string
	}{
		{"git+ssh://git@", ""},
		{"git+https://", ""},
		{"http://", ""},
		{"https://", ""},
		{"git:", ""},
		{"git+", ""},
		{".git", ""},
	}

	for _, repl := range replacements {
		repoURL = strings.ReplaceAll(repoURL, repl.old, repl.new)
	}
	return repoURL
}

func parseScoreCard(resp *resty.Response, commitSha string) *model.Scorecard {
	var scorecard model.Scorecard

	var result ossf.JSONScorecardResultV2
	if err := json.Unmarshal(resp.Body(), &result); err != nil {
		return &scorecard
	}

	if result.Repo.Commit == commitSha {
		scorecard.Pinned = true
		scorecard.CommitSha = commitSha
	}

	scorecard.Score = float32(result.AggregateScore)

	for _, check := range result.Checks {
		name := check.Name
		score := float32(check.Score)

		switch name {
		case "Maintained":
			scorecard.Maintained = score
		case "Code-Review":
			scorecard.CodeReview = score
		case "CII-Best-Practices":
			scorecard.CIIBestPractices = score
		case "License":
			scorecard.License = score
		case "Signed-Releases":
			scorecard.SignedReleases = score
		case "Dangerous-Workflow":
			scorecard.DangerousWorkflow = score
		case "Packaging":
			scorecard.Packaging = score
		case "Token-Permissions":
			scorecard.TokenPermissions = score
		case "Branch-Protection":
			scorecard.BranchProtection = score
		case "Binary-Artifacts":
			scorecard.BinaryArtifacts = score
		case "Pinned-Dependencies":
			scorecard.PinnedDependencies = score
		case "Security-Policy":
			scorecard.SecurityPolicy = score
		case "Fuzzing":
			scorecard.Fuzzing = score
		case "SAST":
			scorecard.SAST = score
		case "Vulnerabilities":
			scorecard.Vulnerabilities = score
		case "CI-Tests":
			scorecard.CITests = score
		case "Contributors":
			scorecard.Contributors = score
		case "Dependency-Update-Tool":
			scorecard.DependencyUpdateTool = score
		case "SBOM":
			scorecard.SBOM = score
		case "Webhooks":
			scorecard.Webhooks = score
		}
	}
	return &scorecard
}

func fetchScoreCardWithCLI(repoURL, commitSha string) *model.Scorecard {
	var scorecard model.Scorecard
	var out strings.Builder

	cmd := exec.Command("scorecard", "--repo="+repoURL, "--commit="+commitSha, "--format", "json")
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return &scorecard
	}

	var result ossf.JSONScorecardResultV2
	if err := json.Unmarshal([]byte(out.String()), &result); err != nil {
		return &scorecard
	}

	if result.Repo.Commit == commitSha {
		scorecard.Pinned = true
		scorecard.CommitSha = commitSha
	}

	scorecard.Score = float32(result.AggregateScore)

	for _, check := range result.Checks {
		name := check.Name
		score := float32(check.Score)

		switch name {
		case "Maintained":
			scorecard.Maintained = score
		case "Code-Review":
			scorecard.CodeReview = score
		case "CII-Best-Practices":
			scorecard.CIIBestPractices = score
		case "License":
			scorecard.License = score
		case "Signed-Releases":
			scorecard.SignedReleases = score
		case "Dangerous-Workflow":
			scorecard.DangerousWorkflow = score
		case "Packaging":
			scorecard.Packaging = score
		case "Token-Permissions":
			scorecard.TokenPermissions = score
		case "Branch-Protection":
			scorecard.BranchProtection = score
		case "Binary-Artifacts":
			scorecard.BinaryArtifacts = score
		case "Pinned-Dependencies":
			scorecard.PinnedDependencies = score
		case "Security-Policy":
			scorecard.SecurityPolicy = score
		case "Fuzzing":
			scorecard.Fuzzing = score
		case "SAST":
			scorecard.SAST = score
		case "Vulnerabilities":
			scorecard.Vulnerabilities = score
		case "CI-Tests":
			scorecard.CITests = score
		case "Contributors":
			scorecard.Contributors = score
		case "Dependency-Update-Tool":
			scorecard.DependencyUpdateTool = score
		case "SBOM":
			scorecard.SBOM = score
		case "Webhooks":
			scorecard.Webhooks = score
		}
	}

	return &scorecard
}

// HealthCheck for kubernetes to determine if it is in a good state
func HealthCheck(c *fiber.Ctx) error {
	return c.SendString("OK")
}

// setupRoutes defines maps the routes to the functions
func setupRoutes(app *fiber.App) {

	app.Get("/swagger/*", swagger.HandlerDefault) // handle displaying the swagger
	app.Get("/msapi/scorecard/*", getScorecard)   // repo + ?commit=<sha>
	app.Get("/health", HealthCheck)               // kubernetes health check

}

// @title Ortelius v11 Scorecard Microservice
// @version 11.0.0
// @description RestAPI for the Scorecard Object
// @description ![Release](https://img.shields.io/github/v/release/ortelius/scec-scorecard?sort=semver)
// @description ![license](https://img.shields.io/github/license/ortelius/.github)
// @description
// @description ![Build](https://img.shields.io/github/actions/workflow/status/ortelius/scec-scorecard/build-push-chart.yml)
// @description [![MegaLinter](https://github.com/ortelius/scec-scorecard/workflows/MegaLinter/badge.svg?branch=main)](https://github.com/ortelius/scec-scorecard/actions?query=workflow%3AMegaLinter+branch%3Amain)
// @description ![CodeQL](https://github.com/ortelius/scec-scorecard/workflows/CodeQL/badge.svg)
// @description [![OpenSSF-Scorecard](https://api.securityscorecards.dev/projects/github.com/ortelius/scec-scorecard/badge)](https://api.securityscorecards.dev/projects/github.com/ortelius/scec-scorecard)
// @description
// @description ![Discord](https://img.shields.io/discord/722468819091849316)

// @termsOfService http://swagger.io/terms/
// @contact.name Ortelius Google Group
// @contact.email ortelius-dev@googlegroups.com
// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html
// @host localhost:3000
// @BasePath /msapi/scorecard
func main() {
	port := os.Getenv("MS_PORT")
	if port == "" {
		port = ":8083"
	} else {
		port = ":" + port
	}

	app := fiber.New()                       // create a new fiber application
	setupRoutes(app)                         // define the routes for this microservice
	if err := app.Listen(port); err != nil { // start listening for incoming connections
		logger.Sugar().Fatalf("Failed get the microservice running: %v", err)
	}
}
