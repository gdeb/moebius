/*eslint-env node */

 module.exports = {
   config: {
     files: {
       javascripts: {
         joinTo: "app.js"
       },
       stylesheets: {
           joinTo: "styles.css",
       }
     },
     plugins: {
       elmBrunch: {
         mainModules: ["app/src/App.elm"],
         outputFolder: "public/"
       }
     }
   }
 };
