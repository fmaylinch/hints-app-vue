<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>All Cards</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon><v-icon>mdi-magnify</v-icon></v-btn>
      <v-btn icon><v-icon>mdi-plus</v-icon></v-btn>
      <v-btn icon><v-icon>mdi-delete</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-list>
          <v-list-item
            v-for="card in cards"
            :key="card.id"
            @click="openCard(card)"
          >
            <v-list-item-content>
              <v-list-item-title class="card-title">
                <span>{{ card.hints[0] }}</span>
                <span>{{ card.hints[1] }}</span>
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import axios from "axios";
import constants from "@/constants.js";

export default {
  name: "CardList",
  data: () => ({
    cards: []
  }),
  created() {
    // TODO: We should do this only once.
    //       This is done every time we go back to the list...
    // TODO: Maybe we don't want a router and just display different components
    //       because the router moves to another page and things are reloaded.
    axios
      .post(constants.apiUrl + "/cards/getAll")
      .then(resp => this.loadCards(resp.data))
      .catch(e => console.error("API Error", e));
  },
  methods: {
    loadCards: function(cards) {
      console.log("Loaded cards");
      this.cards = cards;
    },
    openCard: function(card) {
      // The name of the route is defined in "src/router/index.js".
      // The route definition there doesn't have params, so we're
      // actually passing an object directly. As you can read in
      // https://forum.vuejs.org/t/passing-objects-to-vue-router/32070
      // when the page is reloaded it won't contain the `card`.
      this.$router.push({ name: "EditCard", params: { card: card } });
    }
  }
};
</script>

<style scoped>
.card-title {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
}
</style>
