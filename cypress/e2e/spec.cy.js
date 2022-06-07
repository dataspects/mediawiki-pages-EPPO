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
  it.only("allows a user to add an instance of a EPPO topic type", () => {
    // Fill in form and save
    cy.visit("/w/index.php?title=Special:FormEdit/Aspect");
    cy.get("input[name='Aspect[eppo0:hasEntityTitle]']").type("My title");
    cy.eppoForm_addAProperty("ns0__predicateName", "objectName0");
    cy.eppoForm_addAProperty("ns0__predicateName", "objectName1");
    cy.pageForm_savePage();
    cy.mediawiki_refresh();
    // Initialize property
    cy.get("a").contains("Ns0 predicateName").click();
    cy.pageForm_savePage();
    cy.mediawiki_refresh();
  });

  it("allows a user to refresh a page", () => {
    cy.mediawiki_refresh();
  });
});
