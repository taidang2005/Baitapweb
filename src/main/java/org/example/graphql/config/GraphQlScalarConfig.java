package org.example.graphql.config;

import graphql.scalars.ExtendedScalars;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.graphql.execution.RuntimeWiringConfigurer;

@Configuration
public class GraphQlScalarConfig {

    @Bean("extendedScalarsRuntimeWiringConfigurer")
    public RuntimeWiringConfigurer extendedScalarsRuntimeWiringConfigurer() {
        return wiringBuilder -> wiringBuilder
                // Register ExtendedScalars.DateTime to satisfy schema scalar DateTime
                .scalar(ExtendedScalars.DateTime);
    }
}
