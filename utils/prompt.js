import readline from "readline";

export function prompt(msg) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise(resolve =>
    rl.question(msg, answer => {
      rl.close();
      resolve(answer);
    })
  );
}