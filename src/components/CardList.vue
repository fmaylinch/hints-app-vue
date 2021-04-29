<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>
        Hint Cards
        <span class="title-info">{{titleInfo()}}</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="logout()"><v-icon>mdi-logout-variant</v-icon></v-btn>
      <v-btn icon @click="playCards()"><v-icon>mdi-play</v-icon></v-btn>
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
              <v-progress-linear
                height="1"
                :color="colorForCard(card)"
                :value="card.score">
              </v-progress-linear>
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
import {EventBus} from '@/event-bus.js';
import CardUpdateAction from "@/card-update-action.js";
import Util from "@/util.js";
import Cookies from "js-cookie";

export default {
  name: "CardList",
  created() {
    this.axiosInstance = this.createAxiosInstance();
    this.retrieveCardsFromApi();
    this.listenToCardUpdated();
    this.listenToCardPlayed();
    this.listenToUserLogged();
  },
  data: () => ({
    search: null,
    cards: []
  }),
  computed: {
    searchedCards: function() {
      const lowerSearch = this.search ? this.search.toLowerCase() : "";
      return this.cards.filter(it => it.rawContent.indexOf(lowerSearch) >= 0);
    }
  },
  methods: {
    createAxiosInstance() {
      const jwt = Cookies.get("jwt");
      if (!jwt) {
        return axios.create({ baseURL: constants.apiUrl });
      }
      console.log("Creating axios instance with JWT",  jwt.substring(0, 10) + "...");
      return axios.create({
        baseURL: constants.apiUrl,
        headers: { Authorization: "Bearer " + jwt }
      });
    },
    retrieveCardsFromApi() {
      console.log("Loading cards from API");
      this.axiosInstance
        .post("cards/getAll")
        .then(resp => this.prepareCards(resp.data))
        .catch(e => this.handleError(e));
    },
    listenToCardPlayed() {
      EventBus.$off("card-played");
      EventBus.$on("card-played", event => {
        console.log("Card played", event);
        console.log("Going to edit card");
        // If we go to editCard instantly, there's a strange error
        setTimeout(() => this.editCard(event.card), 50);
      });
    },
    listenToUserLogged() {
      EventBus.$off("user-logged");
      EventBus.$on("user-logged", event => {
        console.log("User logged", event);
        this.axiosInstance = this.createAxiosInstance();
        this.retrieveCardsFromApi();
      });
    },
    logout() {
      Cookies.remove("jwt");
      location.reload();
    },
    listenToCardUpdated() {
      // Remove listener because, when developing, listeners accumulate when vue refreshes.
      EventBus.$off("card-updated");
      EventBus.$on("card-updated", event => {
        console.log("Card updated", event);

        if (event.action === CardUpdateAction.update) {
          console.log("Updating card", event.card.hints[0]);

          this.axiosInstance
            .post("cards/saveOrUpdate", event.card)
            .then(() => this.retrieveCardsFromApi())
            .catch(e => console.error("API Error", e));

        } else if (event.action === CardUpdateAction.delete) {
          console.log("Removing card", event.card.hints[0]);

          this.axiosInstance({
            method: "POST",
            headers: { "content-type": "text/plain" },
            data: event.card.id,
            url: "cards/deleteOne",
          })
            .then(() => this.retrieveCardsFromApi())
            .catch(e => console.error("API Error", e));
        }
      });
    },
    prepareCards(cards) {
      console.log("Preparing cards");
      this.fillRawContent(cards);
      this.cards = cards;
    },
    /** Fills each card.rawContent with lowercase content of all fields, useful for searching */
    fillRawContent(cards) {
      for (let card of cards) {
        card.rawContent = Util.getCardRawContent(card).toLowerCase();
      }
    },
    titleInfo() {
      return this.search
        ? this.searchedCards.length + " of " + this.cards.length
        : this.cards.length;
    },
    colorForCard(card) {
      return Util.colorFromScore(card.score);
    },
    createCard() {
      this.editCard(null);
    },
    playCards() {
      const cardIndex = Math.floor(Math.random() * this.searchedCards.length);
      console.log("Playing card " + cardIndex);
      this.playCard(this.searchedCards[cardIndex]);
    },
    editCard(card) {
      // The name of the route is defined in "src/router/index.js".
      // The route definition there doesn't have params like :id, so we're
      // actually passing an object directly. As you can read in
      // https://forum.vuejs.org/t/passing-objects-to-vue-router/32070
      // when the page is reloaded it won't contain the `card`.
      this.$router.push({ name: "EditCard", params: { card: card } });
    },
    playCard(card) {
      // This works like editCard()
      this.$router.push({ name: "PlayCard", params: { card: card } });
    },
    handleError(error) {
      console.error("API Error:", error);
      if (error.response.status === 401) {
        // We guess we need to login
        this.$router.push({ name: "Login" });
      }
    }
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
