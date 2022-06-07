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

const wait = 1000;

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
