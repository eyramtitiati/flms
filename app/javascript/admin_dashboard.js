//= require jquery
//= require popper
//= require bootstrap


import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function() {
    const locationSelect = document.getElementById("location-select");
    const dateSelect = document.getElementById("date-select");
  
    locationSelect.addEventListener("change", function() {
      const locationId = this.value;
  
      if (locationId) {
        fetch(`/locations/${locationId}/available_dates`)
          .then(response => response.json())
          .then(data => {
            // Clear the previous options
            dateSelect.innerHTML = '';
  
            // Populate the available dates
            data.available_dates.forEach(function(date) {
              const option = document.createElement("option");
              option.value = date;
              option.text = date;
              dateSelect.appendChild(option);
            });
          })
          .catch(error => console.error("Error fetching available dates:", error));
      } else {
        // Clear the date select if no location is selected
        dateSelect.innerHTML = '';
      }
    });
  });
  