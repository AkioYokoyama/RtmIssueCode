extern crate crypto;

use crypto::digest::Digest;
use crypto::md5::Md5;
use std::io;

const FROB_URL: &str = "https://www.rememberthemilk.com/services/auth/";
const AUTH_TOKEN_URL: &str = "https://api.rememberthemilk.com/services/rest/";

pub fn frob() {
    let secret_key = ask(String::from("Enter the 「secret key」"));
    let api_key = ask(String::from("Enter the 「api key」"));

    let code = secret_key + "api_key" + &api_key + "perms" + "read";
    let mut md5 = Md5::new();
    md5.input(code.as_bytes());
    println!("{}?api_key={}&perms=read&api_sig={}", FROB_URL, api_key, md5.result_str());
}

pub fn auth_token() {
    println!("Enter the 「secret key」");
    let mut secret_key = String::new();
    io::stdin().read_line(&mut secret_key).expect("Failed to read_line.");
    let trim_secret_key = secret_key.trim().to_string();

    println!("Enter the 「api key」");
    let mut api_key = String::new();
    io::stdin().read_line(&mut api_key).expect("Failed to read_line.");
    let trim_api_key = api_key.trim().to_string();

    println!("Enter the 「frob」");
    let mut frob = String::new();
    io::stdin().read_line(&mut frob).expect("Failed to read_line.");
    let trim_frob = frob.trim().to_string();

    let code = trim_secret_key + "api_key" + &trim_api_key + "format" + "json" + "frob" + &trim_frob + "method" + "rtm.auth.getToken";
    let mut md5 = Md5::new();
    md5.input(code.as_bytes());
    println!(
        "{}?api_key={}&format=json&frob={}&method=rtm.auth.getToken&api_sig={}",
        AUTH_TOKEN_URL,
        trim_api_key,
        trim_frob,
        md5.result_str()
    );
}

fn ask(question: String) -> String {
    println!("{}", question);
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer).expect("Failed to read_line.");
    return buffer.trim().to_string();
}
