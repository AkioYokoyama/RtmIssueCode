use std::io;

fn main() {
    println!("Enter the number.");
    println!("1. frob");
    println!("2. Auth Token");
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer).expect("Failed to read_line.");

    match buffer.trim().parse().unwrap() {
        1 => issue::frob(),
        2 => issue::auth_token(),
        _ => println!("Enter 1 or 2.")
    }
}
