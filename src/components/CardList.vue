<template>
  <div>
    <header>Card List</header>
    <div v-for="card in cards" :key="card.id">
      {{ card.hints[0] }} = {{ card.hints[1] }}
    </div>
  </div>
</template>

<script>
import axios from "axios";
import constants from "@/constants.js";

export default {
  name: "CardList",
  data() {
    return {
      cards: []
    };
  },
  created() {
    axios
      .post(constants.apiUrl + "/cards/getAll")
      .then(resp => (this.cards = resp.data))
      .catch(e => console.error("API Error", e));
  }
};
</script>

<style scoped>
</style>
