export default class Util {
  static getCardRawContent(card) {
    return card.hints.join(" ") + " " + card.notes + " " + card.score + " " + card.tags.join(" ");
  }
}