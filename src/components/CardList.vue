<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>
        Hint Cards
        <span class="title-info">{{titleInfo()}}</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="createCard()"><v-icon>mdi-plus</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          <v-text-field
            clearable
            v-model="search"
            placeholder="Search…"
          />
        </v-container>
        <v-list>
          <v-list-item
            v-for="card in searchedCards"
            :key="card.id"
            @click="editCard(card)"
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
import { EventBus } from '@/event-bus.js';
import CardUpdateAction from '@/card-update-action.js';

export default {
  name: "CardList",
  props: {
    cards: { type: Array, required: true }
  },
  data: () => ({
    search: null
  }),
  computed: {
    searchedCards: function() {
      const lowerSearch = this.search ? this.search.toLowerCase() : "";
      return this.cards.filter(it => it.rawContent.indexOf(lowerSearch) >= 0);
    }
  },
  methods: {
    titleInfo: function() {
      return this.search ? this.searchedCards.length + " of " + this.cards.length : this.cards.length;
    },
    clearSearch: function() {
      this.search = "";
    },
    createCard: function() {
      this.editCard(null);
    },
    editCard: function(card) {
      // The name of the route is defined in "src/router/index.js".
      // The route definition there doesn't have params, so we're
      // actually passing an object directly. As you can read in
      // https://forum.vuejs.org/t/passing-objects-to-vue-router/32070
      // when the page is reloaded it won't contain the `card`.
      this.$router.push({ name: "EditCard", params: { card: card } });
    }
  },
  created() {
    // Remove listener. When developing the listeners are accumulated when vue refreshes.
    EventBus.$off("card-updated");
    EventBus.$on("card-updated", update => {
      console.log("Card updated", update);
      if (update.action === CardUpdateAction.update) {
        console.log("Updating card");
        axios
          .post(constants.apiUrl + "/cards/saveOrUpdate", update.card)
          .then(() => console.log("Reload cards")) // TODO: send event to App, or move logic here
          .catch(e => console.error("API Error", e));
      }
    });
  }
};
</script>

<style scoped>
.title-info {
  font-size: 0.9rem;
  color: grey;
  padding-left: 8px;
}
.card-title {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  color: darkgrey;
}
</style>
