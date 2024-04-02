$(function () {
  var closestid;
  var closestveh;
  window.addEventListener('message', function (event) {
    switch (event.data.action) {
      case 'opencontract':
        $('.framereceiver #text').text(event.data.playername);
        $('.frameplate #text').text(event.data.plate);
        $('.framereceiver #sign').text(event.data.name);
        $('.container').show();
        closestid = event.data.closestid;
        closestveh = event.data.plate;
        break;
    }
  });
  $('#transfer-button').on('click', function () {
    sound();
    $(".container").hide();
    $(".container2").show();
  });
  $('#confirm-button').on('click', function () {
    sound();
    $(".container2").hide();
    $.post(`https://${GetParentResourceName()}/escape`, JSON.stringify({}));
    $.post(`https://${GetParentResourceName()}/writecontract`, JSON.stringify({player : closestid, vehicle : closestveh}));
  });
  $(document).ready(function () {
    document.onkeyup = function (data) {
      if (data.which == 27) {
        $('.container').hide();
        $('.container2').hide();
        $.post(`https://${GetParentResourceName()}/escape`, JSON.stringify({}));
      }
    };
  });
  function sound() {
    document.getElementById('sound').pause()
    document.getElementById('sound').currentTime = 0
    document.getElementById('sound').volume = 0.5
    document.getElementById('sound').play()
  }
})