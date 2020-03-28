<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>
        All Cards
        <span class="title-info">{{cards.length}}</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon><v-icon>mdi-magnify</v-icon></v-btn>
      <v-btn icon><v-icon>mdi-plus</v-icon></v-btn>
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
export default {
  name: "CardList",
  props: {
    cards: { type: Array, required: true }
  },
  data: () => ({
    // Nothing for now
  }),
  methods: {
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
