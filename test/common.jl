# test/common

using Serde

@testset "LWC_LINE_TYPES" begin
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_SIMPLE) == 0
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_STEP) == 1
end

@testset "LWC_LINE_STYLES" begin
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_SOLID) == 0
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_DOTTED) == 1
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_DASHED) == 2
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_LARGE_DASHED) == 3
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_SPARSE_DOTTED) == 4
end

@testset "PRICE_SCALE_IDs" begin
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_RIGHT) == "right"
    @test Serde.SerJson.ser_type(AbstractChartSettings, LWC_LEFT) == "left"
end

@testset "Data serialization" begin
    data = LWCSimpleChartData(17500000, 0.29)
    result = "{\"time\":\"17500000\",\"value\":0.29}"
    @test Serde.to_json(data) == result
end

@testset "to_camelcase()" begin
    @test LightweightCharts.to_camelcase("price_scale_id") == "priceScaleId"
    @test LightweightCharts.to_camelcase(:line_width) == :lineWidth
end
