//= require prototype
//= require effects
//= require community_engine/builder
//= require dragdrop
//= require controls
//= require community_engine/lightbox
//= require community_engine/prototip-min
//= require tinymce

function scrollToAnchor(anchor){
  loc = document.location.toString();
  if (loc.indexOf("#") != -1){
    parts = loc.split('#')
    loc = parts[0] + '#' + anchor
  } else {
    loc = loc + '#' + anchor
  }
  document.location.href = loc;
}
