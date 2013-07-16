/*jslint browser:true, sloppy: true, plusplus: true */
/*globals $: false, config: false */

var jenkinsDashboard = {
  addTimestampToBuild : function (elements) {
    elements.each(function () {
      var worker = $(this).attr("class"),
      y = parseInt($(this).offset().top + $(this).height() / 2),
      x = parseInt($(this).offset().left + $(this).width() / 2),
      id = x + "-" + y,
      html = '<div class="job_disabled_or_aborted" id="' + id + '">' + worker + '</div>',
      new_element;
      $("#content").append(html);
      new_element = $("#" + id);
      new_element.css("top", parseInt(y - new_element.height() / 2)).css("left", parseInt(x - new_element.width() / 2));
      new_element.addClass('rotate');
      $(this).addClass('workon');
    });
  },
  composeHtmlFragement: function (jobs) {
    var fragment = "<section>",
    jobs_to_be_filtered = config.jobs_to_be_filtered,
    jobs_to_be_excluded = config.jobs_to_be_excluded;
    $.each(jobs, function () {
      if ((jobs_to_be_filtered.length === 0 || $.inArray(this.name, jobs_to_be_filtered) !== -1) && ($.inArray(this.name, jobs_to_be_excluded) === -1) && this.color != 'grey' && this.color != 'disabled') {
        fragment += ("<article class=" + this.color + "><head>" + jenkinsDashboard.filterName(this.name)+ "</head></article>");
      }
    });


    var now = new Date();
    var eastern;
    var pacific;
    /* This only works if you're in Eastern or Pacific time */
    if ( now.getTimezoneOffset() < 301 ) {  
      eastern = now; 
      pacific = new Date(now.getTime() + ( 3 * 60 * 60 * 1000 ))
    } else {
      pacific = now;
      eastern = new Date(now.getTime() - ( 3 * 60 * 60 * 1000 ))
    } 
    var utc = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds());

    fragment += "<article class='utctime'>" + "UTC: " + strftime('%F %T', utc)  + "</article>";
    fragment += "<article class='et_time'>" + "Eastern: " + strftime('%F %T', now)  + "</article>"
    fragment += "<article class='pt_time'>" + "Pacific: " + strftime('%F %T', pacific)  + "</article>"
    fragment += "</section>";
    $("#content").html(fragment);
  },
  updateBuildStatus : function (data) {
    jenkinsDashboard.composeHtmlFragement(data.jobs);
    jenkinsDashboard.addTimestampToBuild($(".disabled, .aborted"));
  },
  filterName: function(name) {
    name = name.replace(/^acceptance\-/, '');
    name = name.replace(/^jslint.*\-/, 'js');
    return name;
  }
};

$(document).ready(function () {

  var ci_url = config.ci_url + "/api/json",
  counter = 0,
  lastData = null,
  auto_refresh;

  if (!ci_url.match(/^http/)) { ci_url = "http://" + ci_url; }
  auto_refresh = setInterval(function () {
    counter++;
    $.jsonp({
      url: ci_url + "?format=json&jsonp=?",
      dataType: "jsonp",
      timeout: 10000,
      beforeSend: function (xhr) {
        if (counter === 1) {
          $.blockUI({
            message: '<h1 id="loading"><img src="img/busy.gif" />loading.....</h1>'
          });
        }
      },
      success: function (data, status) {
        $.unblockUI();
        jenkinsDashboard.updateBuildStatus(data);
      },
      error: function (XHR, textStatus, errorThrown) {
        if ($("#error_loading").length <= 0) {
          $.blockUI({
            message: '<h1 id="error_loading"> Ooooops, check out your network etc. Retrying........</h1>'
          });
        }
      }
    });
  }, 10000);

});
