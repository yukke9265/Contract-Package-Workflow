#include "[PublicHeader]"

#include <cassert>

namespace {

void AT_01_[ShortName]()
{
    // Arrange
    [TestFixtureSetup]

    // Act
    [PrimaryOperation]

    // Assert
    assert([ExpectedBehavior]);
}

void AT_02_[ShortName]()
{
    // Arrange
    [TestFixtureSetup]

    // Act
    [PrimaryOperation]

    // Assert
    assert([ExpectedBehavior]);
}

void AT_03_[ShortName]()
{
    // Arrange
    [TestFixtureSetup]

    // Act
    [PrimaryOperation]

    // Assert
    assert([ExpectedBehavior]);
}

}

int main()
{
    AT_01_[ShortName]();
    AT_02_[ShortName]();
    AT_03_[ShortName]();
}
