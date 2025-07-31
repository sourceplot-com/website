<script lang="ts">
	import type { Live } from "live_svelte";

    export let number: number;
    export let live: Live;

    function increase() {
        live.pushEvent("set_number", {number: number + 1}, () => {})
    }

    function decrease() {
        live.pushEvent("set_number", {number: number - 1}, () => {})
    }
</script>

<p>The number is {number}</p>
<button on:click={increase}>+</button>
<button on:click={decrease}>-</button>
