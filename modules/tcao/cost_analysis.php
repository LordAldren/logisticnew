<?php
session_start();
if (!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    header("location: ../../auth/login.php");
    exit;
}

// RBAC check - Admin lang ang pwedeng pumasok dito
if ($_SESSION['role'] !== 'admin') {
    if ($_SESSION['role'] === 'driver') {
        header("location: ../mfc/mobile_app.php");
    } else {
        header("location: ../../landpage.php");
    }
    exit;
}

require_once '../../config/db_connect.php';

// Fetch Data for AI and Tables
// BAGONG QUERY: Kinukuha na ang fuel, labor, at tolls cost para sa mas magandang AI model
$cost_prediction_data = $conn->query("
    SELECT tc.fuel_cost, tc.labor_cost, tc.tolls_cost, tc.total_cost 
    FROM trip_costs tc
    JOIN trips t ON tc.trip_id = t.id
    WHERE t.status = 'Completed' AND tc.total_cost > 0
");
$prediction_json = json_encode($cost_prediction_data->fetch_all(MYSQLI_ASSOC));

$daily_costs_table_result = $conn->query("
    SELECT
        DATE(t.pickup_time) as trip_date,
        SUM(tc.fuel_cost) as total_fuel,
        SUM(tc.labor_cost) as total_labor,
        SUM(tc.tolls_cost) as total_tolls,
        SUM(tc.total_cost) as grand_total
    FROM trip_costs tc
    JOIN trips t ON tc.trip_id = t.id
    GROUP BY DATE(t.pickup_time)
    ORDER BY trip_date DESC
");
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cost Analysis | TCAO</title>
  <link rel="stylesheet" href="../../assets/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@latest/dist/tf.min.js"></script>
</head>
<body>
  <?php include '../../includes/sidebar.php'; ?>

  <div class="content" id="mainContent">
    <div class="header">
      <div class="hamburger" id="hamburger">☰</div>
      <div><h1>Cost Analysis & Optimization</h1></div>
      <div class="theme-toggle-container">
        <span class="theme-label">Dark Mode</span>
        <label class="theme-switch"><input type="checkbox" id="themeToggle"><span class="slider"></span></label>
      </div>
    </div>
    
    <div class="card">
        <h3>AI Per-Trip Cost Predictor</h3>
        <p>This AI model predicts the total trip cost based on estimated fuel, labor, and toll fees. The more data from completed trips, the more accurate it becomes.</p>
        <div id="ai-predictor-form" style="margin-top: 1.5rem; display: none;">
            <!-- INAYOS ANG FORM: Tatlong input fields na ngayon -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <div class="form-group">
                    <label for="fuel_cost">Estimated Fuel Cost (₱)</label>
                    <input type="number" id="fuel_cost" placeholder="e.g., 1250" class="form-control">
                </div>
                <div class="form-group">
                    <label for="labor_cost">Estimated Labor Cost (₱)</label>
                    <input type="number" id="labor_cost" placeholder="e.g., 500" class="form-control">
                </div>
                <div class="form-group">
                    <label for="tolls_cost">Estimated Tolls Cost (₱)</label>
                    <input type="number" id="tolls_cost" placeholder="e.g., 350" class="form-control">
                </div>
            </div>
            <div class="form-actions" style="justify-content: flex-start;">
                 <button id="predictBtn" class="btn btn-primary">Predict Total Cost</button>
            </div>
            <div id="prediction-output" style="margin-top: 1rem;"></div>
        </div>
        <div id="ai-status" style="margin-top: 1rem;">Training AI model... This may take a moment.</div>
    </div>
    <div class="card">
        <h3>Daily Cost Breakdown Engine</h3>
        <div class="table-section">
            <table>
                <thead><tr><th>Date</th><th>Total Fuel</th><th>Total Labor</th><th>Total Tolls</th><th>Grand Total</th></tr></thead>
                <tbody>
                    <?php if ($daily_costs_table_result && $daily_costs_table_result->num_rows > 0): ?>
                        <?php while($row = $daily_costs_table_result->fetch_assoc()): ?>
                        <tr>
                            <td><strong><?php echo date("M d, Y", strtotime($row['trip_date'])); ?></strong></td>
                            <td>₱<?php echo number_format($row['total_fuel'], 2); ?></td>
                            <td>₱<?php echo number_format($row['total_labor'], 2); ?></td>
                            <td>₱<?php echo number_format($row['total_tolls'], 2); ?></td>
                            <td><strong>₱<?php echo number_format($row['grand_total'], 2); ?></strong></td>
                        </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr><td colspan="5">No daily cost data found. Add trip costs to see analysis.</td></tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

  </div>
     
  <script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('sidebar');
        if (!sidebar) return;

        document.getElementById('hamburger').addEventListener('click', function() {
            const mainContent = document.getElementById('mainContent');
            if (window.innerWidth <= 992) {
                sidebar.classList.toggle('show');
            } else {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('expanded');
            }
        });

        const activeDropdown = sidebar.querySelector('.dropdown.active');
        if (activeDropdown) {
            activeDropdown.classList.add('open');
            const menu = activeDropdown.querySelector('.dropdown-menu');
            if (menu) {
                menu.style.maxHeight = menu.scrollHeight + 'px';
            }
        }

        sidebar.addEventListener('click', function(e) {
            const toggle = e.target.closest('.dropdown-toggle');
            if (!toggle) return;

            e.preventDefault();
            const parent = toggle.closest('.dropdown');
            const menu = parent.querySelector('.dropdown-menu');
            if (!parent || !menu) return;

            sidebar.querySelectorAll('.dropdown.open').forEach(function(otherDropdown) {
                if (otherDropdown !== parent) {
                    otherDropdown.classList.remove('open');
                    otherDropdown.querySelector('.dropdown-menu').style.maxHeight = '0';
                }
            });

            parent.classList.toggle('open');
            if (parent.classList.contains('open')) {
                menu.style.maxHeight = menu.scrollHeight + 'px';
            } else {
                menu.style.maxHeight = '0';
            }
        });

        const predictionData = <?php echo $prediction_json; ?>;
        let costModel;

        async function trainCostModel() {
            const aiStatus = document.getElementById('ai-status');
            if (predictionData.length < 5) { // Needs more data for 3 features
                aiStatus.textContent = 'AI requires more trip cost data to make accurate predictions.';
                aiStatus.style.color = 'var(--warning-color)';
                return;
            }
            
            tf.util.shuffle(predictionData);
            
            // IN-UPDATE: Gumagamit na ng 3 features (fuel, labor, tolls)
            const features = predictionData.map(d => [
                parseFloat(d.fuel_cost) || 0,
                parseFloat(d.labor_cost) || 0,
                parseFloat(d.tolls_cost) || 0
            ]);
            const labels = predictionData.map(d => parseFloat(d.total_cost));
            
            // Normalize features to be between 0 and 1. This helps training.
            const featureTensor = tf.tensor2d(features, [features.length, 3]);
            const labelTensor = tf.tensor2d(labels, [labels.length, 1]);

            const [normalizedFeatures, featureMin, featureMax] = normalizeTensor(featureTensor);
            
            // IN-UPDATE: Mas complex na model na may hidden layer
            costModel = tf.sequential();
            costModel.add(tf.layers.dense({ inputShape: [3], units: 50, activation: 'relu' }));
            costModel.add(tf.layers.dense({ units: 25, activation: 'relu' }));
            costModel.add(tf.layers.dense({ units: 1 }));

            costModel.compile({ 
                optimizer: tf.train.adam(0.01), 
                loss: 'meanSquaredError' 
            });
            
            await costModel.fit(normalizedFeatures, labelTensor, { 
                epochs: 100,
                shuffle: true,
                callbacks: {
                    onEpochEnd: (epoch, logs) => {
                        aiStatus.textContent = `Training AI... Epoch ${epoch + 1}/100, Loss: ${Math.sqrt(logs.loss).toFixed(2)}`;
                    }
                }
            });
            
            aiStatus.textContent = 'AI Model is ready.';
            aiStatus.style.color = 'var(--success-color)';
            document.getElementById('ai-predictor-form').style.display = 'block';

            // Make the model accessible for prediction function
            window.costModel = costModel;
            window.featureMin = featureMin;
            window.featureMax = featureMax;
        }
        
        function normalizeTensor(tensor) {
            const min = tensor.min(0);
            const max = tensor.max(0);
            const normalized = tensor.sub(min).div(max.sub(min));
            return [normalized, min, max];
        }

        document.getElementById('predictBtn').addEventListener('click', () => {
            const fuel = parseFloat(document.getElementById('fuel_cost').value);
            const labor = parseFloat(document.getElementById('labor_cost').value);
            const tolls = parseFloat(document.getElementById('tolls_cost').value);
            const output = document.getElementById('prediction-output');
            
            if (isNaN(fuel) || isNaN(labor) || isNaN(tolls)) {
                output.innerHTML = `<div class='message-banner error'>Please enter valid numbers for all cost fields.</div>`;
                return;
            }

            if (window.costModel) {
                 // Normalize the input using the same min/max from training
                const inputTensor = tf.tensor2d([[fuel, labor, tolls]], [1, 3]);
                const normalizedInput = inputTensor.sub(window.featureMin).div(window.featureMax.sub(window.featureMin));
                
                const prediction = window.costModel.predict(normalizedInput);
                const predictedCost = prediction.dataSync()[0];
                output.innerHTML = `<div class='message-banner success'><strong>Predicted Total Cost:</strong> ₱${predictedCost.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            } else {
                 output.innerHTML = `<div class='message-banner error'>AI model is not ready yet.</div>`;
            }
        });
        
        trainCostModel(); 
    });
  </script>
  <script src="../../assets/js/dark_mode_handler.js" defer></script>
</body>
</html>
