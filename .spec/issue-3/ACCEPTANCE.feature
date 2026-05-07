Feature: Polished Dashboard UI
  As a developer demoing or using the AI Sandbox Patterns dashboard
  I want the UI to be visually polished and professional
  So that the security insights are communicated clearly without visual distractions

  Background:
    Given the dashboard server is running on http://localhost:4321
    And I navigate to http://localhost:4321

  Scenario: AC-1 Header visual polish
    Given the dashboard has loaded
    When I look at the page header
    Then the header should have a clear bottom border separating it from the main content
    And the title "Sandboxing Patterns for AI Runtimes" should be prominently visible
    And the canary secret banner should be visually distinct with a red/danger colour treatment
    And the "Run All Three" button should be visually prominent (primary style)

  Scenario: AC-2 Column card visual polish
    Given the dashboard has loaded
    When I look at the three pattern columns
    Then each column should have a top accent border in its pattern colour (red, amber, green)
    And the column title (Pattern A / B / C) should be clearly readable
    And the subtitle text should be visually secondary (muted colour)
    And the file badge (agent-a.ts etc.) should be styled as a code pill

  Scenario: AC-3 OWASP badge visual polish
    Given the dashboard has loaded
    When I look at the OWASP badge row in each column
    Then fail badges should be red-coloured
    And partial badges should be amber-coloured
    And pass badges should be green-coloured
    And na badges should be muted/grey-coloured
    And all badges should have consistent padding and readable font size

  Scenario: AC-4 Events log visual polish
    Given the dashboard has loaded
    When I look at the events log area in each column
    Then the log area should have clear empty-state text describing the pattern
    And the empty-state text should be in a muted style

  Scenario: AC-5 Status badge visual polish
    Given the dashboard has loaded
    When I look at the status badge next to each Run button
    Then the badge should display "idle" in a muted pill style
    And the badge should have rounded corners (pill shape)

  Scenario: AC-6 Button hover and focus states
    Given the dashboard has loaded
    When I hover over the "Run All Three" button
    Then the button should show a visible hover state change
    When I hover over a "Run" button
    Then the button should show a visible hover state change
    When I tab to focus a button
    Then a visible focus ring should appear

  Scenario: AC-7 Architecture panel toggle polish
    Given the dashboard has loaded
    When I look at the architecture toggle row
    Then the toggle should show "Architecture" label with a direction indicator arrow
    When I click the architecture toggle
    Then the architecture diagrams should collapse smoothly
    When I click the architecture toggle again
    Then the architecture diagrams should expand smoothly

  Scenario: AC-8 Report panel visual polish
    Given the dashboard has loaded
    When I look at the report panel at the bottom of each column
    Then the panel should show "\u2014 waiting for run \u2014" placeholder text
    And the panel heading "report-a.md" etc. should be in small uppercase muted style

  Scenario: AC-9 No horizontal overflow at desktop width
    Given the dashboard has loaded at 1440px viewport width
    When I inspect the page layout
    Then there should be no horizontal scrollbar on the page
    And all three columns should be visible and evenly distributed

  Scenario: AC-10 No functional regressions
    Given the dashboard has loaded
    When I click the "Clear" button
    Then all event logs should reset to the empty-state placeholder text
    And all status badges should show "idle"
    When I click a pattern "Run" button
    Then the button should become disabled
    And the status badge should update to "running"
