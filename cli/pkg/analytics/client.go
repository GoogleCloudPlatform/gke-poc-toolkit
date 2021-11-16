package metrics

import "gkekitctl/pkg/config"

// SendMetrics runs on gkekitctl create. It gets the user's OS, scrubs their project ID data, and sends their create configuration to the metrics server.
/*
NOTES
- Sending metrics is defaulted right now until the init command adds an opt-in/ configurable opt in flag
- The metrics endpoint is hardcoded right now because there's only 1 instance of the metrics server
*/
func SendMetrics(conf *config.Config) error {
	// Get the user's OS
	os := GetOS()
	// Scrub the user's project ID
	scrubbedConf := scrubConfig(conf)
	// Send the user's config to the metrics server
	// TODO
	return nil
}

func scrubConfig(confg *config.Config) *config.Config {
	// Scrub the user's project ID
	scrubbedConf := confg
	scrubbedConf.ProjectID = "REDACTED"
	return scrubbedConf
}
