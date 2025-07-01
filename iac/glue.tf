resource "aws_glue_catalog_database" "poc_database" {
  name = "poc_database"
}

resource "aws_glue_catalog_table" "abalone" {
  catalog_id    = aws_glue_catalog_database.poc_database.catalog_id
  database_name = aws_glue_catalog_database.poc_database.name
  name          = "abalone"
  region        = var.region
  parameters = {
    "classification" = "csv"
  }
  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    input_format              = "org.apache.hadoop.mapred.TextInputFormat"
    location                  = "s3://sm-poc-bucket-jle/abalone/preprocessing/input/"
    output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    stored_as_sub_directories = false

    columns {
      comment = "Sex (M, F, I)"
      name    = "sex"
      parameters = {}
      type    = "string"
    }
    columns {
      comment = "Longest shell measurement (mm)"
      name    = "length"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Perpendicular to length (mm)"
      name    = "diameter"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "With meat in shell (mm)"
      name    = "height"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Whole abalone weight (grams)"
      name    = "whole_weight"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Weight of meat (grams)"
      name    = "shucked_weight"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Weight of gut after bleeding (grams)"
      name    = "viscera_weight"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Weight of shell after being dried (grams)"
      name    = "shell_weight"
      parameters = {}
      type    = "float"
    }
    columns {
      comment = "Predicted age of abalone (years)"
      name    = "rings"
      parameters = {}
      type    = "int"
    }

    ser_de_info {
      parameters = {
        "separatorChar" = ","
      }
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
    }
  }
}