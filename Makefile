build/ne_50m_admin_0_countries.zip:
	mkdir -p $(dir $@)
	curl -o $@ http://www.naturalearthdata.com/download/50m/cultural/$(notdir $@)

build/ne_50m_admin_0_countries.shp: build/ne_50m_admin_0_countries.zip
	unzip -od $(dir $@) $<
	touch $@

build/ne_10m_admin_0_countries.zip:
	mkdir -p $(dir $@)
	curl -o $@ http://www.naturalearthdata.com/download/10m/cultural/$(notdir $@)

build/ne_10m_admin_0_countries.shp: build/ne_10m_admin_0_countries.zip
	unzip -od $(dir $@) $<
	touch $@

build/ne_110m_admin_0_countries.zip:
	mkdir -p $(dir $@)
	curl -o $@ http://www.naturalearthdata.com/download/110m/cultural/$(notdir $@)

build/ne_110m_admin_0_countries.shp: build/ne_10m_admin_0_countries.zip
	unzip -od $(dir $@) $<
	touch $@

build/countries.json: build/ne_110m_admin_0_countries.shp
	ogr2ogr -f GeoJSON -where "CONTINENT IN ('EUROPE', 'ASIA') OR ADM0_A3 IN ('LBY','DZA', 'TUN', 'MAR', 'EGY')" $@ $<

localdata/caribe_official.tsv: localdata/convert.q
	q localdata/convert.q

build/europe.json: build/countries.json localdata/europe_ref_data.tsv
	topojson -o $@ --id-property 'adm0_a3,country' \
	--external-properties localdata/europe_ref_data.tsv \
	--properties quotaKbd=+quotaKbd \
	--properties consumptionKbd=+consumptionKbd \
	--properties actualKbd=+actualKbd \
	--properties products=products \
	--properties infraProjects=infraProjects \
	--properties socialProjects=socialProjects \
	--properties albaAlimentos=albaAlimentos \
	--properties jointVentures=jointVentures \
	--properties joinedYear=joinedYear \
	--properties name=name_long -- $<

public/europe.json: build/europe.json
	cp $< $@