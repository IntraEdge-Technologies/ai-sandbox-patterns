Feature: Dark and Light Mode Switch
  As a user of the AI Sandbox Patterns dashboard
  I want a theme toggle in the top-right header corner
  So that I can switch between dark, light, and system-preferred colour schemes

  Background:
    Given I have the dashboard open at http://localhost:5173

  Scenario: AC-1 Theme toggle exists in header top-right
    Given the dashboard has loaded
    When I look at the top-right area of the header
    Then I see a theme toggle button labelled with the current mode

  Scenario: AC-2 First load defaults to system mode
    Given I have cleared localStorage
    When I reload the dashboard
    Then the html element has data-theme="system"
    And the toggle button reflects "System" as the active mode

  Scenario: AC-3 Clicking cycles through system → light → dark → system
    Given the current theme is "system"
    When I click the theme toggle button
    Then the html element has data-theme="light"
    When I click the theme toggle button again
    Then the html element has data-theme="dark"
    When I click the theme toggle button again
    Then the html element has data-theme="system"

  Scenario: AC-4 Dark mode applies dark background
    Given I click the theme toggle until data-theme is "dark"
    When I inspect the page background colour
    Then the computed background-color of the body is approximately #0d1117

  Scenario: AC-5 Light mode applies light background
    Given I click the theme toggle until data-theme is "light"
    When I inspect the page background colour
    Then the computed background-color of the body is approximately #ffffff

  Scenario: AC-6 System mode inherits OS preference
    Given the current theme is "system"
    When I inspect the html element
    Then data-theme equals "system"
    And the page colour reflects the operating system preference

  Scenario: AC-7 Theme persists across page reload
    Given I set the theme to "dark" via the toggle
    When I reload the page
    Then the html element still has data-theme="dark"
    And the toggle button still reflects "Dark"

  Scenario: AC-8 Toggle button shows correct icon/label per mode
    Given the dashboard is loaded
    When the theme is "system"
    Then the toggle button text contains "System"
    When the theme is "light"
    Then the toggle button text contains "Light"
    When the theme is "dark"
    Then the toggle button text contains "Dark"

  Scenario: AC-9 Toggle is keyboard accessible
    Given the dashboard is loaded
    When I tab to the theme toggle button
    Then it receives a visible focus ring
    When I press Enter on the focused button
    Then the theme cycles to the next value

  Scenario: AC-10 Mermaid diagrams re-render on theme change
    Given the architecture diagrams are visible
    When I switch from dark to light mode
    Then the Mermaid diagram SVGs are re-rendered with the light theme
    When I switch back to dark mode
    Then the Mermaid diagram SVGs are re-rendered with the dark theme
