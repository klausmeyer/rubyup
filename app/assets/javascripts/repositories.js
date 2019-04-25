document.addEventListener('turbolinks:load', function() {
  var master_cbs = document.querySelectorAll("[data-behaviour=toggle-all]");

  master_cbs.forEach(function(master_cb, i) {
    var target_name = master_cb.dataset.target;
    master_cb.addEventListener('click', function(e) {
      var slave_cbs = document.querySelectorAll('input[name="' + target_name + '"]');
      slave_cbs.forEach(function(slave_cb, i) {
        slave_cb.checked = e.target.checked;
        slave_cb.addEventListener('click', function(e) {
          master_cb.checked = false;
        });
      });
    });
  });
});
