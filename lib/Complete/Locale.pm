package Complete::Locale;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
#use Log::Any '$log';

our %SPEC;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(complete_locale);

$SPEC{complete_locale} = {
    v => 1.1,
    summary => 'Complete from list of supported locales on the system',
    args => {
        word => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    result_naked => 1,
};
sub complete_locale {
    my %args = @_;

    my @res;

    require File::Which;
  GET:
    {
        if (File::Which::which('locale')) {
            @res = `locale -a`;
            unless ($?) {
                chomp @res;
                last GET;
            }
        }

        if (File::Which::which('localectl')) {
            @res = `localectl list-locales`;
            unless ($?) {
                chomp @res;
                last GET;
            }
        }
    }

    require Complete::Util;
    Complete::Util::complete_array_elem(
        word => $args{word},
        array => \@res,
    );
}

1;
#ABSTRACT:

=head1 SYNOPSIS

 use Complete::Locale qw(complete_locale);

 my $res = complete_locale(word => 'id');
 # -> ['id_ID.utf8']


=head1 SEE ALSO

L<Complete>
