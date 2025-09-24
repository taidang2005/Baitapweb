package org.example.graphql.config;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.graphql.execution.DataFetcherExceptionResolverAdapter;
import org.springframework.graphql.execution.ErrorType;

@Configuration
public class GraphQlExceptionConfig {

    @Bean
    public DataFetcherExceptionResolverAdapter dataFetcherExceptionResolver() {
        return new DataFetcherExceptionResolverAdapter() {
            @Override
            protected GraphQLError resolveToSingleError(Throwable ex, DataFetchingEnvironment env) {
                if (ex instanceof IllegalArgumentException) {
                    return GraphqlErrorBuilder.newError(env)
                            .message(ex.getMessage())
                            .errorType(ErrorType.BAD_REQUEST)
                            .build();
                }
                // For other runtime exceptions, still expose message (dev-friendly)
                if (ex instanceof RuntimeException) {
                    return GraphqlErrorBuilder.newError(env)
                            .message(ex.getMessage())
                            .errorType(ErrorType.INTERNAL_ERROR)
                            .build();
                }
                return null; // default handling
            }
        };
    }
}
