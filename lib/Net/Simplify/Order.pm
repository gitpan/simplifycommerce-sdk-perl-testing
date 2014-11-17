package Net::Simplify::Order;

=head1 NAME

Net::Simplify::Order - A Simplify Commerce Order object

=head1 SYNOPSIS

  use Net::Simplify;
  use Net::Simplify::Order;

  $Net::Simplify::public_key = 'YOUR PUBLIC KEY';
  $Net::Simplify::private_key = 'YOUR PRIVATE KEY';

  # Create a new Order.
  my $order = Net::Simplify::Order->create{ {...});

  # Retrieve a Order given its ID.
  my $order = Net::Simplify::Order->find('a7e41');

  # Update existing Order.
  my $order = Net::Simplify::Order->find('a7e41');
  $order->{PROPERTY} = "NEW VALUE";
  $order->update();

  # Delete
  my $order = Net::Simplify::Order->find('a7e41');
  $order->delete();

  # Retrieve a list of objects
  my $orders = Net::Simplify::Order->list({max => 10});
  foreach my $v ($orders->list) {
      # ...
  }

=head1 DESCRIPTION

=head2 METHODS

=head3 create(%params, $auth)

Creates a C<Net::Simplify::Order> object.  The parameters are:

=over 4

=item C<%params>

Hash map containing initial values for the object.  Valid keys are:

=over 4

=item customer

Description (B<required>) 

=item customerEmail

Description (B<required>) 

=item customerName

Description (B<required>) 

=item customerNote

Description [max length: 255] 

=item invoice

Description 



=item items.amount

Description 

=item items.description

Description 

=item items.name

Description 

=item items.product

Description 

=item items.quantity

Description [min value: 1, max value: 999999, default: 1] (B<required>) 

=item items.reference

Description [max length: 255] 

=item items.tax

Description 

=item merchantNote

Description [max length: 255] 

=item payment

Description (B<required>) 

=item reference

Description [max length: 255] 

=item shippingAddress

 

=item shippingAddressCity

Description [max length: 255, min length: 2] 

=item shippingAddressCountry

Description [max length: 2, min length: 2, default: US] (B<required>) 

=item shippingAddressLine1

Description [max length: 255] 

=item shippingAddressLine2

Description [max length: 255] 

=item shippingAddressState

Description [max length: 2] 

=item shippingAddressZip

Description [max length: 32] 

=item shippingName

Description (B<required>) 

=item source

Description [default: WEB] (B<required>) 

=item status

Description [default: INCOMPLETE] (B<required>) 


=back

=item C<$auth>

Authentication object for accessing the API.  If no value is passed the global keys
C<$Net::Simplify::public_key> and C<$Net::Simplify::private_key> are used.

=back




=head3 delete()

Deletes the C<Net::Simplify::Order> object.  Authentication is done using the same credentials used when the AccessToken was created.



=head3 list(%criteria, $auth)

Retrieve a list of C<Net::Simplify::Order> objects.  The parameters are:

=over 4

=item C<%criteria>

Hash map representing the criteria to limit the results of the list operation.  Valid keys are:

=over 4

=item C<filter>

Description



=item C<max>

Description [max value: 50, default: 20]



=item C<offset>

Description [default: 0]



=item C<sorting>

Description
The value maps properties to the sort direction (either C<asc> for ascending or C<desc> for descending).  Sortable properties are:

=over 4

=item C<id>

=item C<dateCreated>

=item C<lastUpdated>


=back




=back

=back



=head3 find($id, $auth)

Retrieve a C<Net::Simplify::Order> object from the API.  Parameters are:

=over 4

=item C<$id>

Identifier of the object to retrieve.

=item C<$auth>

Authentication object for accessing the API.  If no value is passed the global keys
C<$Net::Simplify::public_key> and C<$Net::Simplify::private_key> are used.

=back




=head3 update()

Update C<Net::Simplify::Order> object.
The properties that can be updated are:

=over 4


=item C<customerNote>

Description [max length: 255] 


=item C<invoice>

Description 

=item C<merchantNote>

Description [max length: 255] 

=item C<payment>

Description (B<required>) 

=item C<reference>

Description [max length: 255] 

=item C<status>

Description (B<required>) 

Authentication is done using the same credentials used when the AccessToken was created.

=back




=head1 SEE ALSO

L<Net::Simplify>,
L<Net::Simplify::Domain>,
L<Net::Simplify::DomainList>,
L<Net::Simplify::Authentication>,
L<Net::Simplify::ApiException>,
L<http://www.simplify.com>

=head1 VERSION

1.1.0

=head1 LICENSE

Copyright (c) 2013, 2014 MasterCard International Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are 
permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of 
conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of 
conditions and the following disclaimer in the documentation and/or other materials 
provided with the distribution.
Neither the name of the MasterCard International Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from this software 
without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
SUCH DAMAGE.

=head1 SEE ALSO

=cut

use 5.006;
use strict;
use warnings FATAL => 'all';

use Net::Simplify::Domain;
use Net::Simplify::DomainList;

our @ISA = qw(Net::Simplify::Domain);

sub create {

    my ($class, $params, $auth) = @_;
    
    $auth = Net::Simplify::SimplifyApi->get_authentication($auth);
    my $result = Net::Simplify::SimplifyApi->send_api_request("order", 'create', $params, $auth);

    $class->SUPER::new($result, $auth);
}

sub delete {

    my ($self) = @_;

    my $auth = Net::Simplify::SimplifyApi->get_authentication($self->{_authentication});

    my $id = $self->{id};
    $self->merge(Net::Simplify::SimplifyApi->send_api_request("order", 'delete', {id => $id}, $auth));
}

sub list {
    my ($class, $criteria, $auth) = @_;
   
    $auth = Net::Simplify::SimplifyApi->get_authentication($auth);
    my $result = Net::Simplify::SimplifyApi->send_api_request("order", 'list', $criteria, $auth);

    Net::Simplify::DomainList->new($result, $class, $auth);
}

sub find {
    my ($class, $id, $auth) = @_;

    $auth = Net::Simplify::SimplifyApi->get_authentication($auth);
    my $result = Net::Simplify::SimplifyApi->send_api_request("order", 'find', { id => $id }, $auth);

    $class->SUPER::new($result, $auth);
}

sub update {

    my ($self) = @_;

    my $auth = Net::Simplify::SimplifyApi->get_authentication($self->{_authentication});
    my $params = { %$self };
    delete $params->{_authentication};

    $self->merge(Net::Simplify::SimplifyApi->send_api_request("order", 'update', $params, $auth));
}


1;
