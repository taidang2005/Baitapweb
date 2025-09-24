# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Spring Boot 3.5.6 GraphQL application using Java 17 and Maven for build management. The project is configured for WAR packaging and deployment, indicating it's intended for deployment to an external servlet container.

### Technology Stack
- **Framework**: Spring Boot 3.5.6 with Spring Web
- **Data Access**: Spring Data JPA + Spring Data JDBC (dual data access strategy)
- **Java Version**: 17
- **Build Tool**: Maven
- **Packaging**: WAR (for external servlet container deployment)
- **Testing**: JUnit 5 with Spring Boot Test

### Project Structure
```
src/
├── main/
│   ├── java/org/example/graphql/
│   │   ├── GraphqlApplication.java       # Main Spring Boot application class
│   │   └── ServletInitializer.java       # WAR deployment configuration
│   └── resources/
│       └── application.properties        # Spring configuration
└── test/
    └── java/org/example/graphql/
        └── GraphqlApplicationTests.java  # Basic context loading test
```

## Common Development Commands

### Build and Run
```powershell
# Build the project
./mvnw clean compile

# Run tests
./mvnw test

# Package as WAR
./mvnw clean package

# Run the application locally (embedded Tomcat)
./mvnw spring-boot:run

# Clean build artifacts
./mvnw clean
```

### Development Workflow
```powershell
# Quick test-driven development cycle
./mvnw test-compile test

# Run specific test class
./mvnw test -Dtest=GraphqlApplicationTests

# Run with debug enabled
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

# Skip tests during packaging
./mvnw clean package -DskipTests
```

## Architecture Notes

### Current State
This is a minimal Spring Boot GraphQL project scaffold. The application currently only contains:
- Basic Spring Boot configuration
- WAR deployment setup via `ServletInitializer`
- Minimal test infrastructure

### Missing GraphQL Components
The project is set up for GraphQL development but lacks the actual GraphQL dependencies and implementation. To develop GraphQL functionality, you'll need to add:

1. **GraphQL Dependencies**: Add `spring-boot-starter-graphql` to `pom.xml`
2. **Schema Definition**: Create `.graphql` schema files in `src/main/resources/graphql/`
3. **Data Fetchers/Resolvers**: Implement query and mutation resolvers
4. **Models/Entities**: Create JPA entities for data persistence
5. **Services**: Business logic layer between GraphQL and data access

### Data Access Strategy
The project includes both Spring Data JPA and JDBC starters, suggesting:
- **JPA**: For complex entity relationships and ORM capabilities
- **JDBC**: For direct SQL operations and performance-critical queries

### Deployment Architecture
- **Development**: Embedded Tomcat via Spring Boot
- **Production**: WAR deployment to external servlet container
- **Port**: Default Spring Boot port (8080) unless configured otherwise

## Development Guidelines

### Adding GraphQL Functionality
1. Add GraphQL starter dependency to `pom.xml`
2. Create schema files in `src/main/resources/graphql/`
3. Implement `@QueryMapping` and `@MutationMapping` controllers
4. Configure GraphQL endpoint (typically `/graphql`)
5. Add GraphQL testing utilities for integration tests

### Database Integration
1. Configure database connection in `application.properties`
2. Create JPA entities in a `model` or `entity` package
3. Create repositories extending `JpaRepository` or `CrudRepository`
4. Implement service layer for business logic

### Testing Strategy
- Unit tests for individual components
- Integration tests for GraphQL endpoints
- Repository tests for data access layer
- Use `@SpringBootTest` for full application context testing

### Project Structure Expansion
Recommended package structure as the project grows:
```
org.example.graphql/
├── config/          # Configuration classes
├── controller/      # GraphQL resolvers/controllers  
├── model/          # JPA entities and DTOs
├── repository/     # Data access layer
├── service/        # Business logic layer
└── exception/      # Custom exception handling
```