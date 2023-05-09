import { calculator } from "../../../declarations/calculator/index";

const htmlResult = document.querySelector("#result");
const button = document.querySelector("#btn");
const loading = document.querySelector("#loading");
const restart = document.querySelector("#restart");

// get value
(async () => {
  initCalc();

  try {
    const res = await calculator.getCalc();
    console.log({ res });
    htmlResult.innerText = res.toString();
  } catch (err) {
    console.log("get first result error:", err);
  }

  finishCalc();
})();

// listeners
document.querySelector("#form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const operation = document.querySelector("#select").value;
  const num = parseFloat(document.querySelector("#input").value);

  initCalc();

  try {
    switch (operation) {
      case "add":
        const add = await calculator.add(num);
        console.log({ add });
        htmlResult.innerText = add.toString();
        break;
      case "sub":
        const sub = await calculator.sub(num);
        console.log({ sub });
        htmlResult.innerText = sub.toString();
        break;
      case "mult":
        const mult = await calculator.mult(num);
        console.log({ mult });
        htmlResult.innerText = mult.toString();
        break;
      case "div":
        const div = await calculator.div(num); // this return array
        console.log({ div });
        htmlResult.innerText = div[0].toString();
        break;
      default:
        throw new Error("operation no valid");
    }
  } catch (err) {
    console.log(`operation [${operation}] error:`, err);
  }

  finishCalc();
});

restart.addEventListener("click", async () => {
  initCalc();

  try {
    const restart = await calculator.restart();
    console.log({ restart });
    htmlResult.innerText = restart.toString();
  } catch (err) {
    console.log("restart error:", err);
  }

  finishCalc();
});

// functions
function initCalc() {
  button.setAttribute("disabled", true);
  restart.setAttribute("disabled", true);
  htmlResult.style.display = "none";
  loading.style.display = "block";
}

function finishCalc() {
  button.removeAttribute("disabled");
  restart.removeAttribute("disabled");
  htmlResult.style.display = "block";
  loading.style.display = "none";
}
