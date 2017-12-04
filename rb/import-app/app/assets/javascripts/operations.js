$(document).ready(function () {
  var $progressBar = $("#operations-uploader-progress .progress-bar");
  var $uploadReport = $("#upload-status-report");
  var $uploadDetail = $("#upload-status-detail");
  var $uploadDetailTable = $uploadDetail.find("table");
  var $uploadButton = $("#upload-button");

  displayProgressBar = function(shouldDisplay) {
    var $progressBarHolder = $progressBar.parent();
    if (shouldDisplay) { $progressBarHolder.css("display", "flex") }
    else { $progressBarHolder.css("display", "none"); }
  }

  updateProgress = function(progress, shouldAnimated) {
    $progressBar.css("width", progress + "%");
    $progressBar.text(progress + "%");
    if (progress == 100 || shouldAnimated) {
      $progressBar.addClass("progress-bar-striped");
      $progressBar.addClass("progress-bar-animated");
    }
  }

  resetProgress = function() {
    $progressBar.css("width", "0%");
    $progressBar.removeClass("progress-bar-striped");
    $progressBar.removeClass("progress-bar-animated");
    displayProgressBar(false);
  }

  seekProcessingProgress = function(importHistoryId) {
    $.get("/import_history/" + importHistoryId, function(result) {
      var errors = result.errors;
      var rowsCount = result.rows_count;
      var rowsProcessed = result.processed;
      var rowsFailProcessed = result.failed;
      var rowsSuccess = result.success_count;
      var progress = result.progress;

      displayProgressBar(true);
      updateProgress(progress, true);
      $uploadReport.css("display", "block");
      $uploadReport.find(".total-rows-count").text(rowsCount);
      $uploadReport.find(".processed-data-count").text(rowsProcessed);
      $uploadReport.find(".failed-count").text(rowsFailProcessed);
      $uploadReport.find(".success-count").text(rowsSuccess);

      if (progress == 100.0 || progress == 100) {
        resetProgress();
        $uploadButton.css("display", "inline-block");
        if (errors.length > 0) {
          $uploadDetail.css("display", "block");
          $uploadDetailTable.find("tr").remove();
          var $rows = $uploadDetailTable.find("tbody");
          $.each(errors, function(idx, error) {
            var $row = $("<tr>");
            var msg = error.message;
            var rowIdx = error.row;
            $row.append($("<td>").text(rowIdx));
            $row.append($("<td>").text(msg));
            $rows.append($row);
          });
        } // errors length > 0
      } else {
        console.log("Progress not done, seek processing progress in 5 secs");
        setTimeout(function() { seekProcessingProgress(importHistoryId); }, 2000);
      }
    });
  }

  $('#operations-uploader').fileupload({
    dataType: 'json',
    type: 'POST',
    acceptFileTypes: /\.csv$/i,

    submit: function(e, data) {
      $uploadReport.css("display", "none");
      $uploadDetail.css("display", "none");
      $uploadButton.css("display", "none");
      displayProgressBar(true);
    },

    done: function(e, response) {
      var data = response.result; 

      if (!data.success) {
        $uploadButton.css("display", "inline-block");
        if (data.message) {
          alert(data.message);
        } else {
          alert("Error during upload.");
        }
      } else {
        seekProcessingProgress(data.import_history_id);
      }
      resetProgress();
    },

    progressall: function(e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      updateProgress(progress)
    }
  });
})
