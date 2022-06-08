describe("EPPO", () => {
  it("should list all EPPO topic types", () => {
    cy.mediawiki_login("lex", "globi2000globi");
    cy.visit("/wiki/EPPO");
    // #MWSTAKEBP: top-level aspects should be organized in sections
    cy.get("h2").contains("All EPPO topic types");
  });
  it.only("allows a user to add an instance of a EPPO topic type", () => {
    const predicateName = "ns3__predicateName";
    cy.mediawiki_login("lex", "globi2000globi");
    // Fill in form and save
    cy.visit("/w/index.php?title=Special:FormEdit/Aspect");
    cy.eppoForm_editTitle("My title");
    cy.eppoForm_editBlurb("My blurb");
    cy.eppoForm_editFreeText("My free text");
    cy.eppoForm_addAProperty(predicateName, "objectName0");
    cy.eppoForm_addAProperty(predicateName, "objectName1");
    cy.pageForm_savePage();
    cy.mediawiki_refresh();
    // View existing or initialize new property
    cy.dataspects_initializeOrViewProperty(predicateName);
    cy.mediawiki_refresh();
  });

  it("allows a user to refresh a page", () => {
    cy.mediawiki_refresh();
  });
});

describe("EPPO2", () => {});
