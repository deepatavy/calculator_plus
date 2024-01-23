// api.rs
use rustyard::ShuntingYard;

pub fn calculate_result(expression: String) -> String {
    let mut yard = ShuntingYard::new();

    match yard.calculate(&expression) {
        Ok(result) => format!("Result: {}", result),
        Err(err) => format!("Error evaluating expression: {:#?}", err),
    }
}