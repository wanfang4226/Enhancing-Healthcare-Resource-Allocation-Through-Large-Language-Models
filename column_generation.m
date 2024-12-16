% Column Generation for Resource Allocation Problem
% Three objectives: 
% 1. Operating Room Costs (regular + overtime) 
% 2. Surgeon Overtime 
% 3. Peak Bed Usage Minimization

%% Step 1: Initialization

% Parameters
n_days = 5;              % Planning horizon (number of days)
n_or = 5;                % Number of operating rooms
n_surgeons = 5;          % Number of surgeons
regular_or_hours = 8;    % Regular opening hours for OR
max_or_hours = 10;       % Maximum opening hours for OR
or_opening_fee = 1000;   % Opening fee for each OR per day
or_overtime_fee = 200;   % Hourly overtime fee for OR
regular_surgeon_hours = 8; % Regular working hours for surgeon

% Patient Data: [ID, SurgeryDuration, HospitalStay]
patients = [
    1, 4, 2;   % Patient 1: ID=1, Surgery Duration=4, Hospital Stay=2
    2, 5, 3;   % Patient 2: ID=2, Surgery Duration=5, Hospital Stay=3
    3, 3, 1;   % Patient 3: ID=3, Surgery Duration=3, Hospital Stay=1
    4, 6, 2;   % Patient 4: ID=4, Surgery Duration=6, Hospital Stay=2
    5, 2, 2;   % Patient 5: ID=5, Surgery Duration=2, Hospital Stay=2
    6, 4, 3;   % Patient 6: ID=6, Surgery Duration=4, Hospital Stay=3
    7, 5, 1;   % Patient 7: ID=7, Surgery Duration=5, Hospital Stay=1
    8, 3, 2;   % Patient 8: ID=8, Surgery Duration=3, Hospital Stay=2
    9, 4, 1;   % Patient 9: ID=9, Surgery Duration=4, Hospital Stay=1
   10, 6, 3    % Patient 10: ID=10, Surgery Duration=6, Hospital Stay=3
];

n_patients = size(patients, 1); % Number of patients

% Decision variables
x = zeros(n_or, n_days, n_patients); % OR assignment: OR x Day x Patient
surgeon_overtime = zeros(1, n_surgeons); % Overtime hours for surgeons
bed_usage = zeros(1, n_days); % Daily bed usage
patient_assignment = zeros(n_patients, 2); % Patient assignment: [OR, Day]

%% Step 2: Objective Function Definitions
% 1. Operating room costs: regular + overtime
% 2. Surgeon overtime: sum of overtime hours
% 3. Peak bed usage: maximum number of beds occupied in any day

% Weights for objectives
w1 = 0.01; % Weight for OR costs
w2 = 1; % Weight for surgeon overtime
w3 = 1; % Weight for peak bed usage

%% Step 3: Main Loop - Column Generation Simulation

% Initialize cost variables
or_costs = 0; % Total operating room costs
total_surgeon_overtime = 0; % Total surgeon overtime
peak_bed_usage = 0; % Peak bed demand

% Initialize OR usage and surgeon overtime tracking
or_usage = zeros(n_or, n_days);  % Hours used per OR per day
surgeon_hours = zeros(1, n_surgeons); % Hours worked per surgeon

% Assign patients to ORs and calculate metrics
for i = 1:n_patients
    ID = patients(i, 1);              % Patient ID
    SurgeryDuration = patients(i, 2); % Surgery duration (hours)
    HospitalStay = patients(i, 3);    % Hospital stay (days)

    % Simple assignment logic: round-robin assignment to ORs and days
    assigned_or = mod(i-1, n_or) + 1;      % Assigned OR
    assigned_day = mod(i-1, n_days) + 1;   % Assigned day
    
    % Record patient assignment (OR, Day)
    patient_assignment(i, :) = [assigned_or, assigned_day];

    % Update OR usage
    or_usage(assigned_or, assigned_day) = or_usage(assigned_or, assigned_day) + SurgeryDuration;

    % Update bed usage for hospital stay
    for d = 0:HospitalStay-1
        if assigned_day + d <= n_days
            bed_usage(assigned_day + d) = bed_usage(assigned_day + d) + 1;
        end
    end
    
    % Update surgeon hours (assigning surgeons in round-robin)
    assigned_surgeon = mod(i-1, n_surgeons) + 1;
    surgeon_hours(assigned_surgeon) = surgeon_hours(assigned_surgeon) + SurgeryDuration;
end

%% Step 4: Compute Objective Values

% 1. Operating Room Costs: Include opening fee and overtime costs
for d = 1:n_days
    for or = 1:n_or
        if or_usage(or, d) > 0
            or_costs = or_costs + or_opening_fee; % OR opening cost
            overtime = max(0, or_usage(or, d) - regular_or_hours); % Overtime hours
            or_costs = or_costs + or_overtime_fee * overtime; % Overtime cost
        end
    end
end

% 2. Surgeon Overtime: Calculate overtime for all surgeons
for s = 1:n_surgeons
    overtime = max(0, surgeon_hours(s) - regular_surgeon_hours);
    total_surgeon_overtime = total_surgeon_overtime + overtime;
end

% 3. Peak Bed Usage: Maximum beds occupied on any single day
peak_bed_usage = max(bed_usage);

% Weighted objective function
objective_value = w1 * or_costs + w2 * total_surgeon_overtime + w3 * peak_bed_usage;

%% Step 5: Display Results

% Display OR Costs, Surgeon Overtime, Peak Bed Usage, and Objective Value
fprintf('Total Operating Room Costs: %.2f\n', or_costs);
fprintf('Total Surgeon Overtime: %.2f hours\n', total_surgeon_overtime);
fprintf('Peak Bed Usage: %d beds\n', peak_bed_usage);
fprintf('Weighted Objective Value: %.2f\n', objective_value);

% Display Operating Room Usage
disp('Operating Room Usage (hours per day):');
disp(or_usage);

% Display Bed Usage
disp('Daily Bed Usage:');
disp(bed_usage);

% Display Surgeon Workload
disp('Surgeon Hours Worked:');
disp(surgeon_hours);

% Display Patient Assignment (Operating Room and Day)
disp('Patient Assignment (OR, Day):');
disp('Patient ID | Assigned OR | Assigned Day');
for i = 1:n_patients
    fprintf('%d          | %d          | %d\n', patients(i, 1), patient_assignment(i, 1), patient_assignment(i, 2));
end
