beforeEach(() => {
  cy.viewport(1600, 1000);
  cy.mediawiki_login("lex", "globi2000globi");
});

describe("EPPO", () => {
  it("should list all EPPO topic types", () => {
    cy.visit("/wiki/EPPO");
    // #MWSTAKEBP: top-level aspects should be organized in sections
    cy.get("h2").contains("All EPPO topic types");
  });
});
