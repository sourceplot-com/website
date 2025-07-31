import { build, context } from "esbuild";
import ImportGlobPlugin from "esbuild-plugin-import-glob";
import sveltePlugin from "esbuild-svelte";
import { sveltePreprocess } from "svelte-preprocess";

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");

const clientConditions = ["svelte", "browser"];
const serverConditions = ["svelte"];

if (!deploy) {
	clientConditions.push("development");
	serverConditions.push("development");
}

/**
 * @type {import("esbuild").BuildOptions}
 */
const optsClient = {
	entryPoints: ["js/app.js"],
	bundle: true,
	minify: deploy,
	conditions: clientConditions,
	alias: { svelte: "svelte" },
	outdir: "../priv/static/assets",
	logLevel: "info",
	sourcemap: watch ? "inline" : false,
	tsconfig: "./tsconfig.json",
	plugins: [
		ImportGlobPlugin.default(),
		sveltePlugin({
			preprocess: sveltePreprocess(),
			compilerOptions: { dev: !deploy, css: "injected", generate: "client" }
		})
	]
};

/**
 * @type {import("esbuild").BuildOptions}
 */
const optsServer = {
	entryPoints: ["js/server.js"],
	platform: "node",
	bundle: true,
	minify: false,
	target: "node22.17.0",
	conditions: serverConditions,
	alias: { svelte: "svelte" },
	outdir: "../priv/svelte",
	logLevel: "info",
	sourcemap: watch ? "inline" : false,
	tsconfig: "./tsconfig.json",
	plugins: [
		ImportGlobPlugin.default(),
		sveltePlugin({
			preprocess: sveltePreprocess(),
			compilerOptions: { dev: !deploy, css: "injected", generate: "server" }
		})
	]
};

if (watch) {
	context(optsClient)
		.then((ctx) => ctx.watch())
		.catch((_error) => process.exit(1));

	context(optsServer)
		.then((ctx) => ctx.watch())
		.catch((_error) => process.exit(1));
} else {
	build(optsClient);
	build(optsServer);
}
