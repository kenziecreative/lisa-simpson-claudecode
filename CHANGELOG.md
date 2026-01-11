# Changelog

All notable changes to the Lisa plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

### Added - Core Features
- Multi-discipline creative orchestration for Marketing, PR, and Branding teams
- 23 deliverable types across all three disciplines
- Ralph Wiggum Stop hook pattern for autonomous campaign execution
- Quality gates: brand compliance, readability, SEO, AP Style, accessibility
- Campaign brief JSON schema validation

### Added - Memory Systems
- **Agent Memory (Context System)**: Lisa's memory of your company
  - 5 context files: company-profile, brand-voice, style-preferences, core memory, contextual memory
  - Loaded into every campaign for personalized content
  - setup-company skill for document ingestion
  - Context loading during campaign execution
  - Gitignored for privacy
- **Institutional Memory (Learnings Log)**: Campaign insights documentation
  - Automatic learning capture in learnings.txt
  - Append-only log of insights and patterns
  - Committed to git for team knowledge sharing

### Added - Quality & Configuration
- Configurable readability thresholds per deliverable type (based on testing all 23 types)
- Three-tier fallback chain: acceptanceCriteria → user prefs → built-in defaults
- Brand guidelines configuration (brand-config.json)
- Quality check scripts for each discipline
- Comprehensive error messages and troubleshooting

### Added - Documentation
- Complete README with setup instructions for non-technical users
- Context system documentation with annotated examples
- Plain language explanations for marketing/PR professionals
- Troubleshooting guides
- Example workflows for all three disciplines
- Command line basics guide

### Added - Commands & Skills
- /lisa:lisa command - Run campaign with autonomous orchestration
- /lisa:cancel-lisa command - Cancel active campaign
- /lisa:show-memory command - View learned patterns
- setup-company skill - Extract structure from brand documents

### Fixed
- BUG-006: Lisa installation marketplace structure
- BUG-007: Marketplace source type configuration
- BUG-008: marketplace.json schema compliance

### Technical
- All 42 user stories from PRD completed
- Test scripts for context system implementation
- Permission automation for quality checks
- CLAUDE_PLUGIN_ROOT variable detection

## [Unreleased]

### Planned
- Additional deliverable types based on user feedback
- Integration with external tools (CMS, email platforms, media databases)
- Video walkthrough for setup process
- More industry-specific examples

---

[1.0.0]: https://github.com/kenziecreative/lisa/releases/tag/v1.0.0
