// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";
global.toastr = require("toastr")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 画像のプレビュー
// <div id="previewImage">画像</div>                                  切り替えたい画像を囲む
// <%= f.file_field :*, accept: "image/*", id: "imagePreviewForm" %>  file_fieldにidを指定する  "imagePreviewForm"
// 使用箇所  /users/edit, /arts/new, /arts/:id/edit
window.document.addEventListener('turbolinks:load', function() {
    $('#art_image').on("change", (obj) => {
    const files = obj.target.files
    if (files && files[0]) {
      const file = obj.target.files[0]
      const fileReader = new FileReader();
      fileReader.onload = ((e) => {
        const img = new Image()
        img.src = e.target.result
        img.setAttribute( "class", "img-fluid image-preview" )
        $('#previewImage').html(img)
      })
      fileReader.readAsDataURL(file)
    }
  })
})

window.document.addEventListener('turbolinks:load', function() {
    $('#user_thumbnail').on("change", (obj) => {
    const files = obj.target.files
    if (files && files[0]) {
      const file = obj.target.files[0]
      const fileReader = new FileReader();
      fileReader.onload = ((e) => {
        const img = new Image()
        img.src = e.target.result
        img.setAttribute( "class", "thumbnail-m rounded-circle d-block mx-auto" )
        $('#previewThumbnail').html(img)
      })
      fileReader.readAsDataURL(file)
    }
  })
})