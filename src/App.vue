<template>
  <v-app>
    <!-- This will pass this props to all the views -->
    <router-view :cards="cards" />
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
      this.cards = cards;
    }
  }
};
</script>
