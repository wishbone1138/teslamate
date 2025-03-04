defmodule TeslaMate.Vehicles.Vehicle.ChargingTest do
  use TeslaMate.VehicleCase, async: true

  alias TeslaMate.Log.ChargingProcess

  test "logs a full charging cycle", %{test: name} do
    now_ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    events = [
      {:ok, online_event()},
      {:ok, online_event(drive_state: %{timestamp: now_ts, latitude: 0.0, longitude: 0.0})},
      {:ok, charging_event(now_ts + 1, "Starting", 0.1, range: 1)},
      {:ok, charging_event(now_ts + 2, "Charging", 0.2, range: 2)},
      {:ok, charging_event(now_ts + 3, "Charging", 0.3, range: 3)},
      {:ok, charging_event(now_ts + 4, "Complete", 0.4, range: 4)},
      {:ok, charging_event(now_ts + 5, "Complete", 0.4, range: 4)},
      {:ok, charging_event(now_ts + 6, "Unplugged", 0.4, range: 4)},
      {:ok, online_event(drive_state: %{timestamp: now_ts + 7, latitude: 0.2, longitude: 0.2})}
    ]

    :ok = start_vehicle(name, events)

    start_date = DateTime.from_unix!(now_ts, :millisecond)
    assert_receive {:start_state, car, :online, date: ^start_date}
    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online, since: s0}}}

    assert_receive {:start_charging_process, ^car, %{latitude: 0.0, longitude: 0.0},
                    [lookup_address: true]}

    assert_receive {:insert_charge, %ChargingProcess{id: process_id} = cproc,
                    %{
                      date: _,
                      charge_energy_added: 0.1,
                      rated_battery_range_km: 1.6,
                      ideal_battery_range_km: 1.6
                    }}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging, since: s1}}}
    assert DateTime.diff(s0, s1, :nanosecond) < 0

    assert_receive {:insert_charge, ^cproc,
                    %{
                      date: _,
                      charge_energy_added: 0.2,
                      rated_battery_range_km: 3.2,
                      ideal_battery_range_km: 3.2
                    }}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging, since: ^s1}}}

    assert_receive {:insert_charge, ^cproc,
                    %{
                      date: _,
                      charge_energy_added: 0.3,
                      rated_battery_range_km: 4.8,
                      ideal_battery_range_km: 4.8
                    }}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging, since: ^s1}}}

    assert_receive {:insert_position, ^car, %{}}

    assert_receive {:insert_charge, ^cproc,
                    %{
                      date: _,
                      charge_energy_added: 0.4,
                      rated_battery_range_km: 6.4,
                      ideal_battery_range_km: 6.4
                    }}

    # Completed
    assert_receive {:complete_charging_process, ^cproc}

    start_date = DateTime.from_unix!(0, :millisecond)
    assert_receive {:start_state, ^car, :online, date: ^start_date}
    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online, since: s2}}}
    assert DateTime.diff(s1, s2, :nanosecond) < 0

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online, since: ^s2}}}

    refute_receive _
  end

  @tag :capture_log
  test "handles a connection loss when charging", %{test: name} do
    now_ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    events = [
      {:ok, online_event()},
      {:ok, online_event(drive_state: %{timestamp: now_ts, latitude: 0.0, longitude: 0.0})},
      {:ok, charging_event(now_ts + 1, "Charging", 0.1)},
      {:ok, charging_event(now_ts + 2, "Charging", 0.2)},
      {:error, :vehicle_unavailable},
      {:ok, %TeslaApi.Vehicle{state: "offline"}},
      {:error, :vehicle_unavailable},
      {:ok, %TeslaApi.Vehicle{state: "unknown"}},
      {:ok, charging_event(now_ts + 3, "Charging", 0.3)},
      {:ok, charging_event(now_ts + 4, "Complete", 0.3)},
      {:ok, charging_event(now_ts + 5, "Complete", 0.3)},
      {:ok, charging_event(now_ts + 6, "Unplugged", 0.3)},
      {:ok, online_event(drive_state: %{timestamp: now_ts, latitude: 0.2, longitude: 0.2})}
    ]

    :ok = start_vehicle(name, events)

    start_date = DateTime.from_unix!(now_ts, :millisecond)
    assert_receive {:start_state, car, :online, date: ^start_date}
    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online}}}

    assert_receive {:start_charging_process, ^car, %{latitude: 0.0, longitude: 0.0},
                    [lookup_address: true]}

    assert_receive {:insert_charge, %ChargingProcess{id: cproc_id} = cproc,
                    %{date: _, charge_energy_added: 0.1}}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging}}}

    assert_receive {:insert_charge, ^cproc, %{date: _, charge_energy_added: 0.2}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging}}}

    assert_receive {:insert_charge, ^cproc, %{date: _, charge_energy_added: 0.3}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging}}}

    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:insert_charge, ^cproc, %{date: _, charge_energy_added: 0.3}}
    assert_receive {:complete_charging_process, ^cproc}

    start_date = DateTime.from_unix!(0, :millisecond)
    assert_receive {:start_state, ^car, :online, date: ^start_date}
    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online}}}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online}}}

    refute_receive _
  end

  test "Transitions directly into charging state", %{test: name} do
    now_ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    events = [
      {:ok, online_event()},
      {:ok, charging_event(now_ts, "Charging", 22)}
    ]

    :ok = start_vehicle(name, events)

    start_date = DateTime.from_unix!(0, :millisecond)
    assert_receive {:start_state, car, :online, date: ^start_date}
    assert_receive {:insert_position, ^car, %{}}
    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :online}}}

    assert_receive {:start_charging_process, ^car, %{latitude: 0.0, longitude: 0.0},
                    [lookup_address: true]}

    assert_receive {:pubsub, {:broadcast, _, _, %Summary{state: :charging}}}

    assert_receive {:insert_charge, charging_event, %{date: _, charge_energy_added: 22}}
    assert_receive {:insert_charge, ^charging_event, %{date: _, charge_energy_added: 22}}

    # ...

    refute_received _
  end
end
