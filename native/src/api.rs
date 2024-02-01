use rustyard::ShuntingYard;

pub fn calculate_result(expression: String) -> String {
    let formatted_expression = add_spaces_around_operators(expression);
    let mut yard = ShuntingYard::new();

    match yard.calculate(&formatted_expression) {
        Ok(result) => format!("Result: {}", result),
        Err(err) => format!("Error evaluating expression: {:#?}", err),
    }
}

fn add_spaces_around_operators(expression: String) -> String {
    // Define a list of operators
    let operators = vec!['+', '-', '*', '/'];

    // Iterate through each character in the expression
    let formatted_expression: String = expression
        .chars()
        .flat_map(|c| {
            if operators.contains(&c) {
                vec![' ', c, ' '] // Add spaces around operators
            } else {
                vec![c]
            }
        })
        .collect();

    formatted_expression
}