"Adds thousands separators to the given [[integer]]."
String format(Integer integer)
    => Integer.format {
        integer = integer;
        groupingSeparator = ',';
    };

"Pluralizes the given [[string]], if the given [[count]] requires it."
String pluralize(String string, Integer count)
    => count == 1
        then string
        else string + "s";
