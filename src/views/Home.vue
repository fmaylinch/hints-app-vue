<template>
  <div class="home">
    <CardList :cards="cards" />
  </div>
</template>

<script>
// @ is an alias to /src
import CardList from "@/components/CardList.vue";

export default {
  name: "Home",
  props: {
    cards: { type: Array, required: true }
  },
  components: {
    CardList
  }
};
</script>
