// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

//LEX2206071345

const wait = 500;

Cypress.Commands.add("mediawiki_login", (username, password) => {
  cy.visit("/w/index.php?title=Special:UserLogin");
  cy.get("#wpName1").type(username);
  cy.get("#wpPassword1").type(password);
  cy.get("#wpLoginAttempt").click();
});

Cypress.Commands.add("pageForm_cancel", () => {
  cy.wait(wait);
  cy.get("span.oo-ui-labelElement-label").contains("Cancel").parent().click();
});

Cypress.Commands.add("pageForm_savePage", () => {
  cy.wait(wait);
  cy.get("span.oo-ui-labelElement-label")
    .contains("Save page")
    .parent()
    .click();
});

Cypress.Commands.add("eppoForm_addAProperty", (predicate, object) => {
  cy.wait(wait);
  cy.get("span.oo-ui-labelElement-label")
    .contains("Add a property")
    .parent()
    .click();
  cy.wait(wait);
  cy.get("input[origname='Annotation[AnnotationPredicate]']")
    .last()
    .type(predicate)
    .type("{enter}");
  cy.get("input[origname='Annotation[AnnotationObject]']").last().type(object);
});

Cypress.Commands.add("eppoForm_editTitle", (title) => {
  cy.get("input[name='Aspect[eppo0:hasEntityTitle]']").type(title);
});
Cypress.Commands.add("eppoForm_editBlurb", (blurb) => {
  cy.get("textarea[name='Aspect[eppo0:hasEntityBlurb]']").type(blurb);
});
Cypress.Commands.add("eppoForm_editFreeText", (freeText) => {
  cy.get("textarea[name='pf_free_text']").type(freeText);
});

Cypress.Commands.add("mediawiki_refresh", () => {
  cy.get("a").contains("Refresh").click({ force: true });
  cy.get("button")
    .contains("OK")
    .then(($button) => {
      $button.click();
    });
  cy.wait(1000);
});

const predicateNameReformattedBySMW = (predicateName) => {
  return predicateName
    .replace(/^\w/, (c) => c.toUpperCase())
    .replace(/__/, " ");
};

Cypress.Commands.add("dataspects_initializeOrViewProperty", (predicateName) => {
  let pn = predicateNameReformattedBySMW(predicateName);
  cy.get("a")
    .contains(pn)
    .invoke("attr", "class")
    .then((classList) => {
      cy.get("a").contains(pn).click(); // class="new" or
      if (classList && classList.includes("new")) {
        cy.pageForm_savePage();
      }
    });
});
