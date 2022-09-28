// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
    content: [
      "./js/**/*.js",
      "../lib/*_web.ex",
      "../lib/*_web/**/*.*ex"
    ],
    theme: {
      extend: {
        colors: {
          primary: "#b62020",
          secondary: "#ea3b2d",
          tertiary: "#ef5e56",
          quaternary: "#e49f9d",
          quinary: "#ffffff",
          success: "#008F05",
          failure: "#FF4444",
          warning: "#E09200",
          grey: "#f5f5f5",
        },
        fontFamily: {
          montserrat: ["Montserrat"],
        },
      },
    },
    plugins: [
      require('@tailwindcss/aspect-ratio'),
      require("@tailwindcss/forms")
    ],
  }; 