import Chart from "chart.js/auto"

document.addEventListener("turbo:load", () => {

  const ctx = document.getElementById("weightChart")
  if (!ctx) return

  const element = document.getElementById("body-records-data")
  if (!element) return

  const data = JSON.parse(element.textContent)

  new Chart(ctx, {

    type: "line",

    data: {

      labels: data.labels,

      datasets: [

        {
          label: "体重 (kg)",
          data: data.weights,
          borderColor: "rgb(236, 72, 153)",
          backgroundColor: "rgba(236, 72, 153, 0.1)",
          tension: 0.3
        },

        {
          label: "体脂肪 (%)",
          data: data.body_fats,
          borderColor: "rgb(59, 130, 246)",
          backgroundColor: "rgba(59, 130, 246, 0.1)",
          tension: 0.3
        }

      ]

    },

    options: {

      responsive: true,

      plugins: {

        legend: {
          position: "top"
        }

      }

    }

  })

})

