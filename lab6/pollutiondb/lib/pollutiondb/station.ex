defmodule Pollutiondb.Station do
  use Ecto.Schema
  require Ecto.Query

  schema "stations" do
    field :name, :string
    field :lon, :float
    field :lat, :float

    has_many :readings, Pollutiondb.Reading
  end

  defp validate(station, changesmap) do
    station
    |> Ecto.Changeset.cast(changesmap, [:name, :lon, :lat])
    |> Ecto.Changeset.validate_required([:name, :lon, :lat])
    |> Ecto.Changeset.validate_number(
         :lon, greater_than: -180.0, less_than: 180)
    |> Ecto.Changeset.validate_number(
         :lat, greater_than: -100.0, less_than: 100)
  end

  def add(station) do
    station |> Pollutiondb.Repo.insert()
  end

  def add(name, lon, lat) do
    %Pollutiondb.Station{}
    |> validate(%{name: name, lon: lon, lat: lat})
    |> Pollutiondb.Repo.insert()
  end

  def get_by_id(id) do
    Pollutiondb.Repo.get(Pollutiondb.Station, id)
  end

  def get_all() do
    Pollutiondb.Repo.all(Pollutiondb.Station)
    |> Pollutiondb.Repo.preload(:readings)
  end

  def remove(station) do
    Pollutiondb.Repo.delete(station)
  end

  def find_by_name(name) do
    Ecto.Query.where(Pollutiondb.Station, name: ^name)
    |> Pollutiondb.Repo.all()
    |> Pollutiondb.Repo.preload(:readings)
    |> List.first()
  end

  def find_by_location(lon, lat) do
    Ecto.Query.from(s in Pollutiondb.Station,
      where: s.lon == ^lon,
      where: s.lat == ^lat)
    |> Pollutiondb.Repo.all
  end

  def find_by_location_range(lon_min, lon_max, lat_min, lat_max) do
    Ecto.Query.from(
      s in Pollutiondb.Station,
      where: ^lon_min <= s.lon and s.lon <= ^lon_max,
      where: ^lat_min <= s.lat and s.lat <= ^lat_max
    )
    |> Pollutiondb.Repo.all
  end

  def update_name(station, new_name) do
    station
    |> validate(%{name: new_name})
    |> Pollutiondb.Repo.update
  end



end



