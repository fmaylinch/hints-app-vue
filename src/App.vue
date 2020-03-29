<template>
  <v-app>
    <transition>
      <!-- With keep-alive we could keep cards in CardList, instead of in App.vue -->
      <keep-alive include="Home">
        <!-- This will pass this props to all the views -->
        <router-view :cards="cards" />
      </keep-alive>
    </transition>
  </v-app>
</template>

<script>
import axios from "axios";
import constants from "@/constants.js";

export default {
  name: "App",
  data: () => ({
    cards: []
  }),
  created() {
    axios
      .post(constants.apiUrl + "/cards/getAll")
      .then(resp => this.loadCards(resp.data))
      .catch(e => console.error("API Error", e));
  },
  methods: {
    loadCards: function(cards) {
      console.log("Loaded cards");
      this.fillRawContent(cards);
      this.cards = cards;
    },
    /** Fills each card.rawContent with lowercase content of all fields, useful for searching */
    fillRawContent(cards) {
      for (let card of cards) {
        card.rawContent =
          (card.hints.join(" ") + card.notes + card.tags.join(" ")).toLowerCase();
      }
    }
  }
};
</script>
