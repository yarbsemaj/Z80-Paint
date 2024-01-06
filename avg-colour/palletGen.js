const fs = require('fs');

const file = fs.readFileSync('colours.txt').toString();

let output = ""

file.split('\n').forEach((line) => {
    const color = line.replace('#', '')
    const red = parseInt(color.substring(0, 2), 16);
    const green = parseInt(color.substring(2, 4), 16);
    const blue = parseInt(color.substring(4, 6), 16);

    output += `${red}\t${green}\t${blue}\t${color}\n`
})

fs.writeFileSync('colours.gpl', output)