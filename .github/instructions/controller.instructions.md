---
description: 'REST controller rules for Spring Boot'
applyTo: 'src/main/java/**/controller/**/*.java,src/main/java/**/*Controller.java'
---
# Controller-layer rules
- Controllers depend on services only — never on repositories or JPA entities.
- Return ResponseEntity<> with correct HTTP status codes and typed error bodies.
- Validate request bodies with @Valid; reject unknown fields.
- Enforce authorization (@PreAuthorize or gateway policy) on every mapping and
  state the rule assumed.
- No business logic here — delegate to services.
