// const apple = {
//   name: "apple",
//   display: function () {
//     console.log(`${this.name}: 🍎`);
//   },
// };

// const orange = {
//   name: "orange",
//   display: function () {
//     console.log(`${this.name}: 🍊`);
//   },
// };

// 생성자 함수 - 대문자로 시작
function Fruit(name, emoji) {
  this.name = name;
  this.emoji = emoji;
  this.display = () => {
    console.log(`${this.name}: ${this.emoji}`);
  };
}

const apple = new Fruit("apple", "🍎");
const orange = new Fruit("orange", "🍊");

console.log(apple);
console.log(orange);
console.log(apple.name);
console.log(apple.emoji);
apple.display();
